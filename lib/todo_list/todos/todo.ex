defmodule TodoList.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  # alias __MODULE__
  # alias TodoList.Repo

  schema "todos" do
    field :active, :boolean, default: false
    field :done, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :done, :active])
    |> validate_required([:title, :done, :active])
  end
end
