import { cpSync } from "node:fs";

cpSync("manifest.json", "dist/manifest.json");
cpSync("icons", "dist/icons", { recursive: true });

console.log("Build complete: dist/");
