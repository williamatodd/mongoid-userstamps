# Mongoid::Userstamps

Mongoid::Userstamps adds stamp fields for created by, updated by and optionally deleted by
information within a ruby application using Mongoid ORM.

This is a fork from [mongoid_userstamp](https://github.com/tbpro/mongoid_userstamp) but it
has been completely rewritten to provide with some new feature and improvements.

## Install

```ruby
  gem 'mongoid-userstamps'
```

## Usage

Mongoid::Userstamps does the following:
* Defines Mongoid `belongs_to` relations to the user class for `created_by` and `updated_by` on each class where `Mongoid::Userstamps` is included
* Adds the possibility to define only `created_by` or `updated_by` by including `Mongoid::Userstamps::Created` or `Mongoid::Userstamps::Updated` respectively
* Automatically tracks the current user via a `before_filter` (see Rails Integration below)
* Sets the `created_by` and `updated_by` values in `before_create` and `before_save` callbacks respectively on the target models.
* Adds methods to the user class to check for the current user.
* Defines `belongs_to` relation to the user class for `deleted_by` when the class includes `Mongoid::Paranoia` or when `Mongoid::Userstamps::Deleted` is specifically included

```ruby
  # Default config (optional unless you want to customize the values)
  Mongoid::Userstamps.config do |c|
    c.user_reader = :current_user
    c.created_name = :created_by
    c.updated_name = :updated_by
    c.deleted_name = :deleted_by
  end

  # Example model class
  class Product
    include Mongoid::Document
    include Mongoid::Userstamps

    # optional class-level config override
    # mongoid_userstamp user_model: 'MyUser',
    #                   created_name: :creator,
    #                   updated_name: :updater,
  end
 
  # Example user class
  class MyUser
    include Mongoid::Document
    include Mongoid::Userstamps::User

    # optional class-level config override
    # mongoid_userstamp_user reader: :current_my_user
  end

  # Create instance
  p = Product.create

  # Creator ObjectID   |   Updater ObjectID
  p.created_by_id      |   p.updated_by_id
  # => BSON::ObjectId('4f7c719f476da850ba000039')

  # Creator instance   |   Updater instance
  p.created_by         |   p.updated_by
  # => <User _id: 4f7c719f476da850ba000039>

  # Set creator/updater manually (usually not required)
  p.created_by = MyUser.where(name: 'Will Smith')
  p.updated_by = MyUser.where(name: 'DJ Jazzy Jeff')
```


## Preservation of Manually-set Values

Mongoid::Userstamps will not overwrite manually set values in the creator and updater fields. Specifically:

* The creator is only set during the creation of new models (`before_create` callback). Mongoid::Userstamps will not
overwrite the creator field if it already contains a value (i.e. was manually set.)
* The updater is set each time the model is saved (`before_save` callback), which includes the initial
creation. Mongoid::Userstamps will not overwrite the updater field if it been modified since the last save, as
per Mongoid's built-in "dirty tracking" feature.
* The same logic goes for the deleter field if `Mongoid::Userstamps::Deleted` is included.


## Rails Integration

Popular Rails authentication frameworks such as Devise and Sorcery make a `current_user` method available in
your Controllers. Mongoid::Userstamps will automatically use this to set its user reference in a `before_filter`
on each request. (You can set an alternative method name via the `user_reader` config.)

*Gotcha:* If you have special controller actions which change/switch the current user to a new user, you will
need to set `User.current = new_user` after the switch occurs.


## Thread Safety

Mongoid::Userstamps stores all-related user variables in `Thread.current`. If the
[RequestStore](https://github.com/steveklabnik/request_store) gem is installed, Mongoid::Userstamps
will automatically store variables in the `RequestStore.store` instead. RequestStore is recommended
for threaded web servers like Thin or Puma.


## Advanced Usage: Scoped Execution

It is possible to execute a block of code within the context of a given user as follows:

```ruby
User.current = staff
User.current          #=> staff

User.sudo(admin) do
  my_model.save!
  User.current        #=> admin
end

User.current          #=> staff
```


## Advanced Usage: Multiple User Classes

Most Rails apps use a single user model. However, Mongoid::Userstamps supports using multiple user models
at once, and will track a separate current_user for each class.

Please note that each model may subscribe to only one user type for its userstamps, set via the
`:user_model` option.

```ruby
  class Admin
    include Mongoid::Document
    include Mongoid::Userstamps::User

    mongoid_userstamp_user reader: :current_admin
  end

  class Customer
    include Mongoid::Document
    include Mongoid::Userstamps::User

    mongoid_userstamp_user reader: :current_customer
  end

  class Album
    include Mongoid::Document
    include Mongoid::Userstamps

    mongoid_userstamp user_model: 'Customer'
  end

  class Label
    include Mongoid::Document
    include Mongoid::Userstamps

    mongoid_userstamp user_model: 'Admin'
  end

  # Set current user for each type
  Admin.current = Admin.where(name: 'Biz Markie')
  Customer.current = Customer.where(name: 'Sir Mix-A-Lot')

  # In your Controller action
  album = Album.new('Baby Got Back Single')
  album.save!
  album.created_by.name   #=> 'Sir Mix-A-Lot'

  label = Label.new('Cold Chillin Records')
  label.save!
  label.created_by.name   #=> 'Biz Markie'
```

## Contributing

Fork -> Patch -> Test -> Push -> Pull Request

Please use Ruby 1.9.3 hash syntax, as Mongoid 3 requires Ruby >= 1.9.3

## Authors

* [Geoffroy Planquart](https://github.com/Aethelflaed)
* [Thomas Boerger](http://www.tbpro.de)
* [John Shields](https://github.com/johnnyshields)
* [Bharat Gupta](https://github.com/Bharat311)

## Copyright

Licensed under the MIT License (MIT). Refer to LICENSE for details.

