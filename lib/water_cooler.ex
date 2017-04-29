defmodule WaterCooler do
  use Plug.Router
  alias WaterCooler.ChatRoom
  require EEx

  EEx.function_from_file(:def, :home_page, "lib/templates/home_page.html.eex")

  plug :match
  plug :dispatch

  get "/", do: resp(conn, 200, home_page())

  post "/" do
    {:ok, body, conn} = read_body(conn)
    body
    |> parse_publish_form()
    |> ChatRoom.publish()

    send_resp(conn, 200, "message sent!")
  end

  get "/updates" do
    ChatRoom.join()
    conn
    |> put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
    |> listen()
  end

  defp listen(conn) do
    receive do
      {:message, message} ->
        chunk(conn, "event: chat\ndata: #{message}\n\n")
    end
    listen(conn)
  end

  defp parse_publish_form(raw) do
    %{"message" => message} = URI.decode_www_form(raw) |> URI.decode_query
    message
  end

end
