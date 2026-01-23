using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
//tess

class Program
{
    string framework = RuntimeInformation.FrameworkDescription;
    static string feedbackText = "";
    static volatile bool feedbackActive = false;
    static volatile bool countdownCancelled = false;
    static char pendingAction = '\0';
    static double sharedFrame = 0;
    static readonly object frameLock = new();

    static readonly string[] BannerTemplate =
    {
        @"",
        @"",
        @"",
        @"                      ████████╗  ██████╗   ██████╗  ██╗      ██████╗   ██████╗  ██╗  ██╗     ╔═════════════╗",
        @"                      ╚══██╔══╝ ██╔═══██╗ ██╔═══██╗ ██║      ██╔══██╗ ██╔═══██╗ ╚██╗██╔╝     ║   Version   ║",
        @"                         ██║    ██║   ██║ ██║   ██║ ██║      ██████╔╝ ██║   ██║  ╚███╔╝      ║{VERSION}║",
        @"                         ██║    ██║   ██║ ██║   ██║ ██║      ██╔══██╗ ██║   ██║  ██╔██╗      ║             ║",
        @"                         ██║    ╚██████╔╝ ╚██████╔╝ ███████╗ ██████╔╝ ╚██████╔╝ ██╔╝ ██╗     ║{STATUS}║",
        @"                         ╚═╝     ╚═════╝   ╚═════╝  ╚══════╝ ╚═════╝   ╚═════╝  ╚═╝  ╚═╝     ╚═════════════╝"
    };

    static readonly string[] MenuLines =
    {
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"",
        @"                                                                                             ╔═»  [    Update   ] [U]",
        @"                                                                                             ╠═»  [    PW Gen   ] [P]",
        @"  #═╦══════════════════════════════════╦═════════════════════════════════════════════════════╬═»  [     Exit    ] [E]",
        @"    ╠═══════» [     Cleaner     ] [1]  ╠═══════» [   Task Manager  ] [6]                     ╠═»  [   Credits   ] [C]",
        @"    ╠═══════» [   Kill VMware   ] [2]  ╠═══════» [ Registry Editor ] [7]                     ╚═»  [ Information ] [I]",
        @"    ╠═══════» [ Kill VirtualBox ] [3]  ╠═══════» [  Control Panel  ] [8]",
        @"    ╠═══════» [     Settings    ] [4]  ╠═══════» [  Command Prompt ] [9]",
        @"    ╠═══════» [    Utilities    ] [5]  ╚═══════» [   System Info   ] [0]",
        @"    ║"
    };

    static readonly int[] Palette = { 240, 242, 245, 247, 249, 251, 253 };

    static string localVersion = "Unknown";
    static string statusText = "Checking...";
    static readonly string versionFile = Path.Combine(AppContext.BaseDirectory, "Updater\\Version.txt");

    static int feedbackLine;
    static readonly object consoleLock = new();

    static readonly Dictionary<char, (string name, Action handler)> menuActions = new();

    static async Task Main()
    {
        // FIRST THING: ensure ANSI support silently
        EnableAnsiSupport();

        // now safe to use console features
        Console.OutputEncoding = System.Text.Encoding.UTF8;
        Console.InputEncoding = System.Text.Encoding.UTF8;
        Console.Title = "Toolbox - Ghost";

        try
        {
#pragma warning disable CA1416
            Console.SetWindowSize(120, 30);
            Console.SetBufferSize(120, 30);
#pragma warning restore CA1416
        }
        catch { }

        try
        {
            Console.CursorVisible = false;
        }
        catch { }

        feedbackLine = BannerTemplate.Length + MenuLines.Length;

        InitializeMenuActions();
        DrawMenuAndBanner();

        using CancellationTokenSource cts = new();
        var token = cts.Token;

        Task bannerTask = AnimateBannerGradient(token);
        Task menuTask = AnimateMenuGradient(token);
        Task versionTask = LiveVersionChecker(token);
        Task inputTask = WaitForKeyWithFeedback(token);
        Task promptTask = AnimatePrompt(token);

        await Task.WhenAll(bannerTask, menuTask, versionTask, inputTask, promptTask);
    }


    static void EnableAnsiSupport()
    {
        try
        {
            // Check if ANSI is already enabled
            var checkAnsi = new ProcessStartInfo
            {
                FileName = "cmd.exe",
                Arguments = "/c reg query HKCU\\Console /v VirtualTerminalLevel 2>nul | findstr /r /c:\"0x1\" >nul",
                UseShellExecute = false,
                CreateNoWindow = true
            };

            var checkProcess = Process.Start(checkAnsi);
            checkProcess?.WaitForExit();

            if (checkProcess?.ExitCode != 0) // ANSI not enabled
            {
                // Enable ANSI
                var setAnsi = new ProcessStartInfo
                {
                    FileName = "reg",
                    Arguments = "add HKCU\\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f",
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                Process.Start(setAnsi)?.WaitForExit();

                // Restart silently
                Process.Start(new ProcessStartInfo
                {
                    FileName = Environment.ProcessPath, // current executable
                    UseShellExecute = true,
                    CreateNoWindow = true, // ensure no new console pops up
                });

                Environment.Exit(0); // exit current instance
            }
        }
        catch
        {
            // ignore silently
        }
    }

    static void InitializeMenuActions()
    {
        menuActions.Add('1', ("Cleaner", () => RunBatchScript("Files\\Cleaner.bat")));
        menuActions.Add('2', ("Kill VMware", () => RunBatchScript("Files\\VMware.bat")));
        menuActions.Add('3', ("Kill VirtualBox", () => RunBatchScript("Files\\VirtualBox.bat")));
        menuActions.Add('4', ("Settings", () => RunBatchScript("Files\\Settings.bat")));
        menuActions.Add('5', ("Utilities", () => RunBatchScript("Files\\Utilities.bat")));
        menuActions.Add('6', ("Task Manager", () => RunBatchScript("Files\\TaskManager.bat")));
        menuActions.Add('7', ("Registry Editor", () => RunBatchScript("Files\\RegistryEditor.bat")));
        menuActions.Add('8', ("Control Panel", () => RunBatchScript("Files\\ControlPanel.bat")));
        menuActions.Add('9', ("Command Prompt", () => RunBatchScript("Files\\CommandPrompt.bat")));
        menuActions.Add('0', ("System Info", () => RunBatchScript("Files\\SystemInfo.bat")));
        menuActions.Add('C', ("Credits", () => RunBatchScript("Files\\ToolboxCredits.bat")));
        menuActions.Add('I', ("Information", () => RunBatchScript("Files\\Information.bat")));
        menuActions.Add('P', ("PW Gen", () => RunBatchScript("Files\\PasswordGen.bat")));
        menuActions.Add('U', ("Update", () => RunBatchScript("Updater\\Update-Toolbox.bat")));
    }

    static void DrawMenuAndBanner()
    {
        lock (consoleLock)
        {
            int bannerHeight = BannerTemplate.Length;
            for (int y = 0; y < bannerHeight; y++)
            {
                string line = BannerTemplate[y]
                    .Replace("{VERSION}", CenterText(localVersion, 13))
                    .Replace("{STATUS}", CenterText(statusText, 13));
                Console.SetCursorPosition(0, y);
                Console.Write(line.PadRight(Console.WindowWidth));
            }

            for (int i = 0; i < MenuLines.Length; i++)
            {
                Console.SetCursorPosition(0, bannerHeight + i);
                Console.Write(MenuLines[i].PadRight(Console.WindowWidth));
            }
        }
    }

    static async Task AnimateBannerGradient(CancellationToken token)
    {
        int bannerHeight = BannerTemplate.Length;

        while (!token.IsCancellationRequested)
        {
            double currentFrame;
            lock (frameLock)
            {
                currentFrame = sharedFrame;
            }

            for (int y = 0; y < bannerHeight; y++)
            {
                string line = BannerTemplate[y]
                    .Replace("{VERSION}", CenterText(localVersion, 13))
                    .Replace("{STATUS}", CenterText(statusText, 13));

                lock (consoleLock)
                {
                    Console.SetCursorPosition(0, y);
                    var output = new System.Text.StringBuilder(line.Length * 30);
                    for (int x = 0; x < line.Length; x++)
                    {
                        double p = (y - currentFrame + x * 0.25) % Palette.Length;
                        if (p < 0) p += Palette.Length;
                        int i1 = (int)Math.Floor(p);
                        int i2 = (i1 + 1) % Palette.Length;
                        double t = p - i1;
                        int c = (int)Math.Round(Palette[i1] * (1 - t) + Palette[i2] * t);
                        output.Append($"\x1b[38;5;{c}m{line[x]}\x1b[0m");
                    }
                    output.Append(new string(' ', Console.WindowWidth - line.Length));
                    Console.Write(output.ToString());
                }
            }

            lock (frameLock)
            {
                sharedFrame = (sharedFrame + 0.19) % Palette.Length;
            }
            await Task.Delay(1, token);
        }
    }

    static async Task AnimateMenuGradient(CancellationToken token)
    {
        int bannerHeight = BannerTemplate.Length;
        int menuHeight = MenuLines.Length;

        while (!token.IsCancellationRequested)
        {
            double currentFrame;
            lock (frameLock)
            {
                currentFrame = sharedFrame;
            }

            for (int i = 0; i < menuHeight; i++)
            {
                string line = MenuLines[i];
                int y = bannerHeight + i;

                lock (consoleLock)
                {
                    Console.SetCursorPosition(0, y);
                    var output = new System.Text.StringBuilder(line.Length * 30);
                    for (int x = 0; x < line.Length; x++)
                    {
                        double p = ((bannerHeight + i) - currentFrame + x * 0.20) % Palette.Length;
                        if (p < 0) p += Palette.Length;
                        int i1 = (int)Math.Floor(p);
                        int i2 = (i1 + 1) % Palette.Length;
                        double t = p - i1;
                        int c = (int)Math.Round(Palette[i1] * (1 - t) + Palette[i2] * t);
                        output.Append($"\x1b[38;5;{c}m{line[x]}\x1b[0m");
                    }
                    output.Append(new string(' ', Console.WindowWidth - line.Length));
                    Console.Write(output.ToString());
                }
            }

            await Task.Yield();
        }
    }

    static async Task AnimatePrompt(CancellationToken token)
    {
        const string idleText = "    ╚═══════> ";
        while (!token.IsCancellationRequested)
        {
            string textToDraw = feedbackActive ? feedbackText : idleText;

            lock (consoleLock)
            {
                Console.SetCursorPosition(0, feedbackLine);
                Console.Write(textToDraw.PadRight(Console.WindowWidth));
            }

            await Task.Delay(50, token);
        }
    }

    static async Task WaitForKeyWithFeedback(CancellationToken token)
    {
        const string prompt = "    ╚═══════> ";

        while (!token.IsCancellationRequested)
        {
            if (!Console.KeyAvailable)
            {
                await Task.Delay(10, token);
                continue;
            }

            char key = char.ToUpperInvariant(Console.ReadKey(true).KeyChar);

            feedbackActive = true;
            countdownCancelled = false;
            pendingAction = key;

            for (int i = 3; i > 0 && !countdownCancelled; i--)
            {
                feedbackText = $"{prompt}{key} Running In {i}... (Press E To Cancel)";

                var startTime = DateTime.UtcNow;
                var targetTime = startTime.AddMilliseconds(1000);

                while (DateTime.UtcNow < targetTime && !countdownCancelled)
                {
                    if (Console.KeyAvailable)
                    {
                        char cancelKey = char.ToUpperInvariant(Console.ReadKey(true).KeyChar);
                        if (cancelKey == 'E')
                        {
                            countdownCancelled = true;
                            break;
                        }
                    }

                    var remaining = (targetTime - DateTime.UtcNow).TotalMilliseconds;
                    if (remaining > 50)
                    {
                        await Task.Delay(50, token);
                    }
                    else if (remaining > 0)
                    {
                        await Task.Delay((int)remaining, token);
                    }
                }
            }

            if (countdownCancelled)
            {
                feedbackText = $"{prompt}{key} Cancelled.";
                await Task.Delay(1000, token);
                feedbackActive = false;
                pendingAction = '\0';
                continue;
            }

            if (pendingAction == 'E')
            {
                feedbackText = $"{prompt}{key} Exiting...";
                await Task.Delay(500, token);
                Environment.Exit(0);
                return;
            }
            else if (menuActions.ContainsKey(pendingAction))
            {
                var action = menuActions[pendingAction];
                feedbackText = $"{prompt}{key} Running {action.name}...";
                await Task.Delay(500, token);

                try
                {
                    action.handler();
                    feedbackText = $"{prompt}{key} {action.name} Running.";
                }
                catch (Exception ex)
                {
                    feedbackText = $"{prompt}{key} Error: {ex.Message}";
                }

                await Task.Delay(2000, token);
            }
            else
            {
                feedbackText = $"{prompt}{key} Invalid Option.";
                await Task.Delay(1000, token);
            }

            feedbackActive = false;
            pendingAction = '\0';
        }
    }

    static async Task LiveVersionChecker(CancellationToken token)
    {
        await Task.Delay(1000, token);

        while (!token.IsCancellationRequested)
        {
            try
            {
                localVersion = File.Exists(versionFile) ? File.ReadAllText(versionFile).Trim() : "Unknown";
                string? latest = await GetLatestRelease("SimonGhost1012", "Toolbox");

                if (string.IsNullOrEmpty(latest))
                {
                    statusText = CenterText("Unknown", 13);
                }
                else
                {
                    string normalizedLocal = NormalizeVersion(localVersion);
                    string normalizedLatest = NormalizeVersion(latest);

                    statusText = normalizedLatest == normalizedLocal
                        ? CenterText("Up-To-Date!", 13)
                        : CenterText("Update!", 13);
                }
            }
            catch
            {
                statusText = CenterText("Unknown", 13);
            }

            await Task.Delay(30000, token);
        }
    }

    static string NormalizeVersion(string version)
    {
        if (string.IsNullOrEmpty(version) || version == "Unknown") return version;
        return version.Trim().TrimStart('v', 'V');
    }

    static async Task<string?> GetLatestRelease(string owner, string repo)
    {
        try
        {
            using HttpClient client = new();
            client.DefaultRequestHeaders.UserAgent.ParseAdd("Toolbox");
            var response = await client.GetAsync($"https://api.github.com/repos/{owner}/{repo}/releases/latest");

            if (!response.IsSuccessStatusCode) return null;

            using JsonDocument doc = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
            return doc.RootElement.TryGetProperty("tag_name", out var tag) ? tag.GetString() : null;
        }
        catch { return null; }
    }

    static void HandleKeyAction(char key)
    {
        if (key == 'E')
            Environment.Exit(0);
    }

    static string CenterText(string text, int width)
    {
        if (text.Length >= width) return text[..width];
        int left = (width - text.Length) / 2;
        return new string(' ', left) + text + new string(' ', width - text.Length - left);
    }

    static void RunBatchScript(string scriptPath)
    {
        try
        {
            Process.Start(new ProcessStartInfo
            {
                FileName = scriptPath,
                UseShellExecute = true
            });
        }
        catch
        {
            throw new Exception($"Could Not Run {scriptPath}");
        }
    }

    static void CheckForUpdates()
    {
        try
        {
            Process.Start(new ProcessStartInfo
            {
                FileName = "cmd.exe",
                Arguments = "/c echo Checking For Updates... & timeout /t 3 & echo Update Check Complete.",
                UseShellExecute = true
            });
        }
        catch
        {
            throw new Exception("Could Not Check For Updates");
        }
    }
}