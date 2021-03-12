# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Seeds for the transaction database
# Includes example users, merchants, and transactions
alias Homework.Repo
alias Homework.Users
alias Homework.Users.User
alias Homework.Merchants
alias Homework.Merchants.Merchant
alias Homework.Transactions
alias Homework.Transactions.Transaction

# User seeds
%User{first_name: "paul", last_name: "andersen", dob: "01011900"} |> Repo.insert!()
%User{first_name: "dwayne", last_name: "johnson", dob: "05021972"} |> Repo.insert!()
%User{first_name: "amanda", last_name: "nunes", dob: "05301988"} |> Repo.insert!()
%User{first_name: "barbara", last_name: "Streisand", dob: "04241942"} |> Repo.insert!()
%User{first_name: "FrAn", last_name: "LeBoWiTz", dob: "010271950"} |> Repo.insert!()
paul = Users.get_users_where_name!("paul", "andersen")
barbara = Users.get_users_where_name!("barbara", "Streisand")
fran = Users.get_users_where_name!("FrAn", "LeBoWiTz")

# Merchant seeds
%Merchant{name: "paulco", description: "for all your paul needs!"} |> Repo.insert!()
%Merchant{name: "divvide", description: "like divvy but a different name"} |> Repo.insert!()
paulco = Merchants.get_merchants_where_name!("paulco")
divvide = Merchants.get_merchants_where_name!("divvide")

# Transaction seeds
%Transaction{amount: 1, credit: false, debit: true, description: "bought a paul", merchant_id: paulco.id, user_id: paul.id}
%Transaction{amount: 1, credit: true, debit: false, description: "bought a paul", merchant_id: paulco.id, user_id: fran.id}
%Transaction{amount: 1, credit: false, debit: true, description: "bought a borger", merchant_id: divvide.id, user_id: barbara.id}
%Transaction{amount: 1, credit: false, debit: true, description: "bought a borger", merchant_id: divvide.id, user_id: fran.id}