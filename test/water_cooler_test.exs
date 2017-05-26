defmodule WaterCoolerTest do
  use ExUnit.Case
  use Plug.Test
  require Mock
  doctest WaterCooler

  alias WaterCooler.ChatRoom

  test "Home page is available" do
    conn = get("/")
    assert conn.status == 200
  end

  test "Random page is not found" do
    response = get("/random")
    assert response.status == 404
  end

  test "Can post a message" do
    ChatRoom.join()
    conn = post("/", "message=Hello")
    assert conn.status == 200
    assert_receive {:message, "Hello"}, 1_000
  end

  test "Update is streamed to client" do
    Task.async(fn -> get("/updates") end)

    home = self()
    chunk_mock = fn _conn, chunk -> send(home, chunk) end
    Mock.with_mock(Plug.Conn, [:passthrough], chunk: chunk_mock) do

      ChatRoom.publish("Greetings!")
      assert_receive "event: chat\ndata: Greetings!\n\n", 10

    end
  end

  def get(path) do
    conn(:get, path) |> WaterCooler.call(nil)
  end

  def post(path, data) do
    conn(:post, path, data) |> WaterCooler.call(nil)
  end

end
