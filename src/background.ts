const NATIVE_HOST = "com.tabbar.toggle";

chrome.commands.onCommand.addListener((command: string) => {
  if (command !== "toggle-vertical-tabs") return;
  chrome.runtime.sendNativeMessage(NATIVE_HOST, { action: "toggle" });
});
