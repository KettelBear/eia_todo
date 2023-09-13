defmodule Todo.List do

  alias __MODULE__, as: TList
  @moduledoc false

  defimpl String.Chars, for: __MODULE__ do
    def to_string(list) do
      "#{inspect(list)}" |> String.replace("%", "#", global: false)
    end
  end

  defimpl Collectable, for: __MODULE__ do
    def into(original), do: {original, &into_callback/2}

    defp into_callback(_todo_list, :halt), do: :ok
    defp into_callback(todo_list, :done), do: todo_list
    defp into_callback(todo_list, {:cont, entry}) do
      TList.create(todo_list, entry)
    end
  end

  defstruct [auto_id: 1, entries: %{}]

  def new(entries \\ []) do
    Enum.reduce(entries, %__MODULE__{}, &create(&2, &1))
  end

  def create(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %__MODULE__{auto_id: todo_list.auto_id + 1, entries: new_entries}
  end

  def read(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update(todo_list, %{id: id} = new_entry) do
    update(todo_list, id, fn _ -> new_entry end)
  end
  def update(todo_list, entry_id, updater) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, %{id: old_id} = old} ->
        new = %{id: ^old_id} = updater.(old)
        new_entries = Map.put(todo_list.entries, new.id, new)
        %__MODULE__{todo_list | entries: new_entries}
    end
  end

  def delete(%__MODULE__{entries: entries} = todo_list, entry_id) do
    %__MODULE__{todo_list | entries: Map.delete(entries, entry_id)}
  end
end
