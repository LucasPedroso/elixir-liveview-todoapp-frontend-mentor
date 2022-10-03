defmodule TodoListWeb.PageLiveTest do
  use TodoListWeb.ConnCase
  import Phoenix.LiveViewTest
  alias TodoList.Todos

  test "disconnected and connected mount", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Todo"
    assert render(page_live) =~ "Create a new todo..."
  end

  test "toggle an todo", %{conn: conn} do
    {:ok, todo} = Todos.create_todo(%{"title" => "Learn Elixir"})
    assert todo.done == false

    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :toggle, %{"id" => todo.id, "value" => true}) =~ "completed"

    updated_todo = Todos.get_todo!(todo.id)
    assert updated_todo.done == true
  end

end
