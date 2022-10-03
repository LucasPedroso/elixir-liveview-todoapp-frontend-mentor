defmodule TodoListWeb.LayoutView do
  use TodoListWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def checked?(todo) do
    if not is_nil(todo.done) and todo.done == true, do: true, else: false
  end

  def completed?(todo) do
    if not is_nil(todo.done) and todo.done == true, do: "completed", else: ""
  end

  def allCompleted?(todos) do
    if isAllTodosDone?(todos), do: "completed", else: ""
  end

  def checkboxId?(todo) do
    "checkbox-#{todo.id}"
  end

  def todoId?(todo) do
    "dark-#{todo.id}"
  end

  def isAllTodosDone?(todos) do
    Enum.all?(todos, fn todo -> todo.done == true end)
  end
end
