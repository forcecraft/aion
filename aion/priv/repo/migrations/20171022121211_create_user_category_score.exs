defmodule Aion.Repo.Migrations.CreateUserCategoryScore do
  use Ecto.Migration

  def change do
    create table(:user_category_scores) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
      add :score, :integer, default: 0

      timestamps()
    end
    create index(:user_category_scores, [:user_id])
    create index(:user_category_scores, [:category_id])

  end
end
