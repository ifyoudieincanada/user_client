# UserClient

A client to interact with UserService.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `user_client` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:user_client, git: "https://github.com/ifyoudieincanada/user_client.git"}]
    end
    ```

  2. Ensure `user_client` is started before your application:

    ```elixir
    def application do
      [applications: [:user_client]]
    end
    ```

  3. Add `url` environment variable to `config/config.exs`

    ```elixir
    config :user_client,
      url: System.get_env("USER_SERVICE_URL")
    ```
