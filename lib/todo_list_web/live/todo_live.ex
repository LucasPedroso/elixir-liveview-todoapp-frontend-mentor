defmodule TodoListWeb.TodoLive do
  use TodoListWeb, :live_view
  alias TodoList.Todos
  alias Ecto.Repo


  @topic "live"

  def mount(_params, _session, socket) do
    # subscribe to the channel
    socket = assign(socket, editing: nil, todosIncomplete: 0)

    if connected?(socket), do: TodoListWeb.Endpoint.subscribe(@topic)
    {:ok, fetch(socket)} # add items to assigns
  end

  def render(assigns) do
    ~L"Rendering LiveView"
  end

  def handle_event("create", %{"text" => title}, socket) do
    Todos.create_todo(%{title: title})
    socket = fetch(socket)
    TodoListWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.delete_todo(todo)
    socket = fetch(socket)
    TodoListWeb.Endpoint.broadcast_from(self(), @topic, "delete", socket.assigns)
    {:noreply, socket}
  end

  def handle_event("toggle", data, socket) do
    done = if Map.has_key?(data, "value"), do: true, else: false
    todo = Todos.get_todo!(Map.get(data, "id"))
    Todos.update_todo(todo, %{id: todo.id, done: done})
    socket = fetch(socket)
    TodoListWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end

  def handle_event("check-all-todos", data, socket) do
    done = if Map.has_key?(data, "value"), do: true, else: false

    todos = Todos.list_todos()

    Enum.each(todos, fn(todo) ->
      Todos.update_todo(todo, %{done: done})
    end)

    socket = fetch(socket)

    TodoListWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end

  def handle_event("edit-todo", data, socket) do
    {:noreply, assign(socket, editing: String.to_integer(data["id"]))}
  end

  def handle_event("update-todo", %{"id" => todo_id, "text" => title}, socket) do
    current_item = Todos.get_todo!(todo_id)
    Todos.update_todo(current_item, %{title: title})
    socket = assign(socket, todos: Todos.list_todos(), editing: nil)
    TodoListWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end

  def handle_event("clear-completed", _data, socket) do
    Todos.clear_completed()
    todos = Todos.list_todos()
    {:noreply, assign(socket, todos: todos)}
  end

  def handle_info(%{event: "update", payload: %{todos: todos}}, socket) do
    {:noreply, assign(socket, todos: todos)}
  end

  def handle_params(params, _url, socket) do
    todos = Todos.list_todos();

    case params["filter_by"] do
      "completed" ->
        completed = Enum.filter(todos, &(&1.done == true))
        {:noreply, assign(socket, todos: completed)}
      "active" ->
        active = Enum.filter(todos, &(&1.done == false))
        {:noreply, assign(socket, todos: active)}

      _ ->
        {:noreply, assign(socket, todos: todos)}
    end
  end

  defp fetch(socket) do
    assign(socket, todos: Todos.list_todos(), todosIncomplete: Todos.get_incomplete_todos_length())
  end

end
