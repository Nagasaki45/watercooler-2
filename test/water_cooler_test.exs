defmodule WaterCoolerTest do
  use ExUnit.Case
  use Plug.Test
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
    # response = get("/updates")
    # assert "chunked" == :proplists.get_value("transfer-encoding", response.headers)
    # assert [chunk] = info(ChatRoom.post("Greetings!"))
    # {event, _} = ServerSentEvent.parse(chunk)
    # assert %{type: "chat", lines: ["Greetings!"]} = event
  end

  def get(path) do
    conn(:get, path) |> WaterCooler.call(nil)
  end

  def post(path, data) do
    conn(:post, path, data) |> WaterCooler.call(nil)
  end

end
