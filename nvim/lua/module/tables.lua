local M = {}
M.newline_char = {
  dos = "\r\n",
  unix = "\n",
  mac = "\r",
}
M.project_root_patterns = {
  ".git/",
  ".svn/",
  ".hg/",
  ".bzr/",
  ".gitignore",
  "Rakefile",
  "pom.xml",
  "project.clj",
  "package.json",
  "manifest.json",
  "*.csproj",
  "*.sln",
}
return M
