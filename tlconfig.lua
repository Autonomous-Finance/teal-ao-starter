return {
  source_dir = "src",
  include_dir = { "src", "typedefs" },
  include = {
    "**/*.tl",
  },
  build_dir = "build-lua",
  global_env_def = "ao"
}
