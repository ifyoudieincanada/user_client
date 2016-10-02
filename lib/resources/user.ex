defmodule UserClient.User do
  alias UserClient.HTTP

  @type t :: %{
    id:       integer,
    username: String.t,
    email:    String.t,
    token:    String.t,
    password: String.t
  }

  defstruct [:id, :username, :email, :token, :password]

  @spec verify(user :: __MODULE__.t) :: {:ok, __MODULE__.t} | {:error, any}
  def verify(user) do
    with {:ok, response} <- HTTP.post(url("/verify"), %{"token" => user.token}) do
      {:ok, to_user(response)}
    end
  end

  @spec login(user :: __MODULE__.t) :: {:ok, __MODULE__.t} | {:error, any}
  def login(user) do
    with {:ok, response} <- HTTP.post(url("/login"), to_payload(user)) do
      {:ok, to_user(response)}
    end
  end

  def has_permission?(user, permission_name) do
    with {:ok, response} <- HTTP.get(url("/#{user.id}"), %{"permission" => permission_name}) do
      {:ok, Map.get(response, "bool")}
    end
  end

  @spec create(user :: __MODULE__.t) :: {:ok, __MODULE__.t} | {:error, any}
  def create(user) do
    with {:ok, response} <- HTTP.post(url("/"), to_payload(user)) do
      {:ok, to_user(response)}
    end
  end

  @spec update(user :: __MODULE__.t) :: {:ok, __MODULE__.t} | {:error, any}
  def update(user) do
    with {:ok, response} <- HTTP.put(url("/#{user.id}"), to_payload(user)) do
      {:ok, to_user(response)}
    end
  end

  @spec delete(user :: __MODULE__.t) :: {:ok, nil} | {:error, any}
  def delete(user) do
    with {:ok, _response} <- HTTP.delete(url("/#{user.id}"), %{"token" => user.token}) do
      {:ok, nil}
    end
  end

  defp to_user(response) do
    %__MODULE__{
      id: get_in(response, ["user", "id"]),
      username: get_in(response, ["user", "username"]),
      email: get_in(response, ["user", "email"]),
      token: Map.get(response, "token")
    }
  end

  defp to_payload(user) do
    %{
      "user" => %{
        "id" => user.id,
        "username" => user.username,
        "email" => user.email,
        "password_tmp" => user.password
      },
      "token" => user.token
    }
  end

  defp url(extension) do
    Path.join([Application.get_env(:user_client, :url), "/users", extension])
  end
end
