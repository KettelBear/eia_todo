defmodule TodoList.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo_list,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps, do: []
end

