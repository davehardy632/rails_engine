Welcome to Rails Engine!

This application is a fictitious ecommerce api that renders JSON responses based on a given range of HTTP URL requests. The data used consists of 6 CSV documents, customers, invoices, invoice items, items, merchants and transactions.

This Application uses Ruby version 2.4.1, and Rails 5.2.3

> Getting Up and Running

  - clone the application
  
  - cd into the repository from the command line
  
  Run the following commands
  
  $ bundle
  
  To set up the database, run the following..
  
  $ rails db:create
  $ rails db:migrate
  
  The CSV documents for the application are included in the repository, to import them to the database, run the following command.
  
  $ rails import:prospect
  
  As indicated above, the application uses rspec for testing, to run the tests, type in rspec to run all tests, or rspec spec/api/v1/(which ever test file you choose).rb
  for model testing run, rspec spec/models, or rspec spec/models/(model file name here).rb
  
  And with that you should be up and running!
  
  For a list of record endpoints that the application responds to, run any of the following in the URL of your browser after starting your local server by running ( $ rails s ) from the command line, all of the given responses will return a Formatted JSON response.
  
  Merchants
  
 /api/v1/merchants/:id/items returns a collection of items associated with that merchant
 /api/v1/merchants/:id/invoices returns a collection of invoices associated with that merchant from their known orders
  Invoices

 /api/v1/invoices/:id/transactions returns a collection of associated transactions
 /api/v1/invoices/:id/invoice_items returns a collection of associated invoice items
 /api/v1/invoices/:id/items returns a collection of associated items
 /api/v1/invoices/:id/customer returns the associated customer
 /api/v1/invoices/:id/merchant returns the associated merchant
Invoice Items

 /api/v1/invoice_items/:id/invoice returns the associated invoice
 /api/v1/invoice_items/:id/item returns the associated item
 
Items

 /api/v1/items/:id/invoice_items returns a collection of associated invoice items
 /api/v1/items/:id/merchant returns the associated merchant
 
Transactions

 /api/v1/transactions/:id/invoice returns the associated invoice
 
Customers

 /api/v1/customers/:id/invoices returns a collection of associated invoices
 /api/v1/customers/:id/transactions returns a collection of associated transactions
