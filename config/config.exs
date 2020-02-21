import Config

if Mix.env() != :prod do
  config :git_hooks,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          "mix format --check-formatted"
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          "mix dialyzer",
          "mix test",
          "echo 'success!'"
        ]
      ]
    ]
end
