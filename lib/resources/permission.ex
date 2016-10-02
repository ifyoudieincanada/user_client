defmodule UserClient.Permission do
  alias UserClient.HTTP
  alias UserClient.User

  @type t :: %{
    id:           integer,
    name:         String.t,
    description:  String.t
  }

  defstruct [:id, :name, :description, :user_id]

  @spec index :: {:ok, [__MODULE__.t]} | {:error, any}
  def index do
    with {:ok, response} <- HTTP.get(url("/")) do
      response = response
                 |> Map.get("data")
                 |> Enum.map(fn permission ->
                   to_permission(permission)
                 end)
      {:ok, response}
    end
  end

  @spec create(__MODULE__.t, User.t, User.t) :: {:ok, __MODULE__.t} | {:error, any}
  def create(permission, user, admin) do
    payload = to_payload(permission)
              |> Map.put("token", admin.token)
              |> Map.put("user_id", user.id)

    with {:ok, response} <- HTTP.post(url("/"), payload) do
      to_permission(response)
    end
  end

  @spec delete(__MODULE__.t, User.t) :: {:ok, nil} | {:error, any}
  def delete(permission, admin) do
    with {:ok, _response} <- HTTP.post(url("/#{permission.id}"), %{"token" => admin.token}) do
      {:ok, nil}
    end
  end

  defp to_permission(response) do
    %__MODULE__{
      id: Map.get(response, "id"),
      name: Map.get(response, "name"),
      description: Map.get(response, "description")
    }
  end

  defp to_payload(permission) do
    %{
      "permission" => %{
        "id" => permission.id,
        "name" => permission.name,
        "description" => permission.description
      }
    }
  end

  defp url(extension) do
    Path.join([Application.get_env(:user_client, :url), "/permissions", extension])
  end
end
