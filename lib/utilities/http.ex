defmodule UserClient.HTTP do
  def get(url, payload \\ %{}, headers \\ %{}) do
    Client.do_request(url,
                      payload,
                      headers,
                      Client.Encoders.GETURLEncoded,
                      Client.Decoders.JSON,
                      &Client.get(&1, &2, &3))
  end

  def post(url, payload \\ %{}, headers \\ %{}) do
    Client.do_request(url,
                      payload,
                      headers,
                      Client.Encoders.JSON,
                      Client.Decoders.JSON,
                      &Client.post(&1, &2, &3))
  end

  def patch(url, payload \\ %{}, headers \\ %{}) do
    Client.do_request(url,
                      payload,
                      headers,
                      Client.Encoders.JSON,
                      Client.Decoders.JSON,
                      &Client.patch(&1, &2, &3))
  end

  def put(url, payload, headers \\ %{}) do
    Client.do_request(url,
                      payload,
                      headers,
                      Client.Encoders.JSON,
                      Client.Decoders.JSON,
                      &Client.put(&1, &2, &3))
  end

  def delete(url, headers) do
    Client.do_request(url,
                      %{},
                      headers,
                      Client.Encoders.NilEncoder,
                      Client.Decoders.JSON,
                      &Client.delete(&1, &2, &3))
  end
end
