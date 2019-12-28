Rails GraphQL Launchpad
===

A starting point for GraphQL endpoints running on Rails, powered by [graphql-ruby](https://github.com/rmosolgo/graphql-ruby).

## Installation

1. Clone the boilerplate (or use Github template)

    ```sh
    git clone git@github.com:arempe93/rails-graphql-boilerplate.git myproject
    ```
2. Change application configs

    TODO comments have been placed where changes need to be made. View them easily with

    ```sh
    rake notes
    ```

3. Setup local environment

    ```sh
    rake setup
    ```

That's all!

## Features

### GraphiQL IDE

Makes use of [graphiql-rails](https://github.com/rmosolgo/graphiql-rails) to give you a GraphQL IDE mounted at `/graphql`

![graphiql](https://cloud.githubusercontent.com/assets/2231765/12101544/4779ed54-b303-11e5-918e-9f3d3e283170.png)

### Apollo Query Batching Support

Supports Apollo query batching (and all query batching using the `_json` method) out of the box.

_For more information, see this [blog post](https://blog.apollographql.com/batching-client-graphql-queries-a685f5bcd41b)_

### GraphQL Preload

A field extension that leverages the [graphql-batch](https://github.com/Shopify/graphql-batch) gem by Shopify to simplify Rails association preloading.

Associations are batched and loaded with [`ActiveRecord::Associations::Preloader`](https://www.rubydoc.info/docs/rails/ActiveRecord/Associations/Preloader)

**Simple example**
```ruby
class UserType < BaseObject
  # assuming User => has_many :devices
  field :devices, [DeviceType], null: false, preload: true
end
```

**Nested example**
```ruby
class CourseType < BaseObject
  # assuming
  # - Course => has_many :course_students
  # - CourseStudents => has_many :students
  field :students, [StudentType], null: false do
    # preload and preload_scope can also be called as methods here
    preload course_students: :students
  end
end
```

**Scoped example**
```ruby
class CourseType < BaseObject
  field :grades, [GradeType], null: false do
    preload assignments: :grade
    # can alternatively provide a Proc that is given the following keywords:
    # - object: tthe resolved object (usually a type)
    # - arguments: the arguments given to the field
    # - context: the graphql context
    preload_scope :grade_preload_scope
  end

  def grade_preload_scope
    Grade.where(student_id: context[:current_student_id])
  end
end
```

_For more information about preloading and preload scopes please see the [Rails documentation](https://www.rubydoc.info/docs/rails/ActiveRecord/Associations/Preloader)._

### GraphQL Authorize

A field extension that allows you to specify authorization logic on a per-field basis.

To create this logic, you create `GraphQLAuthorize::Policy` classes to describe discrete conditions.


```ruby
class Authenticated < GraphQLAuthorize::Policy
  # the call method is provided the following keywords:
  # - object: the resolved object (usually a type)
  # - arguments: the arguments given to the field
  # - context: the graphql context
  # - field: the field object being evaluated
  def call(context:, **)
    context[:user_id].present?  # the return value of call is treated as true/false
  end
end

class AttendsCourse < GraphQLAuthorize::Policy
  def call(object:, **)
    course_id = object.object.id

    CourseAttendance.exist?(user_id: context[:user_id], course_id: course_id)
  end
end
```

You can then use policy objects directly:

```ruby
class QueryType < BaseObject
  field :current_user, UserType, null: false do
    authorize Authenticated.new
  end
end
```

Or chain them with other policies

```ruby
class CourseType < BaseObject
  field :syllabus, SyllabusType, null: false do
    authorize Authenticated.new.and(AttendsCourse.new)
  end
end
```

#### Important notes

1. When using chaining (`Policy#and` / `#or` methods), policies are executed in order and a failing condition does not end the process.

    ```ruby
      class Failure < GraphQLAuthorize::Policy
        def call(**)
          puts "Failure#call"
          false
        end
      end

      authorize Failure.new.and(Failure.new)
      # STDOUT => "Failure.call" (x2)
    ```

2. Policies are just objects, so you can add extra data at initialization

    ```ruby
    class PermissionLevel < GraphQLAuthorize::Policy
      def initialize(level)
        @level = level
      end

      def call(context:, **)
        context[:permission] >= @level
      end
    end

    class QueryContext < BaseObject
      field :all_users, [UserType], null: false do
        authorize PermissionLevel.new(PermissionEnum::ADMIN)
      end
    end
    ```

3. Similarily you can also freeze objects for efficiency and ease of use.

    ```ruby
    # you can create pre-configured policies:
    module Policies
      USER = PermissionLevel.new(PermissionEnum::USER).freeze
      ADMIN = PermissionLevel.new(PermissionEnum::ADMIN).freeze
      SUPERADMIN = PermissionLevel.new(PermissionEnum::SUPERADMIN).freeze

      ELEVATED = ADMIN.or(SUPERADMIN).freeze
    end

    # then use:
    authorize Policies::ELEVATED
    ```

### GraphQL Type Generator

Includes a Rails generator for creating a GraphQL type and entity file for an Active Record model.

```sh
rails g type User
```

_Outputs:_

```ruby
# app/graphql/types/user_type.rb
module Types
  class UserType < BaseObject
    include Timestamps

    # includes all database columns as fields
    field :id, ID, null: false
    field :email, String, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false

    # even generates association fields!
    # it's only based on the name however so make sure the type exists
    field :devices, [DeviceType], null: false, preload: true do
      entity Entities::DeviceEntity
    end
  end
end

# app/graphql/entities/user_entity.rb
module Entities
  class UserEntity < BaseEntity
  end
end
```

### Automatic Model Annotation

```ruby
# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  email                :string(255)      not null
#  first_name           :string(128)      not null
#  last_name            :string(128)      not null
#  role                 :string(32)
#  phone_number         :string(32)
#  hashed_password      :string(64)
#  password_reset_token :string(64)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
```

### Global Configuration

I find the [global](https://github.com/railsware/global) gem helpful for storing environment specific application configurations

### Local Environment Bootstap

Uses [dotenv-rails](https://github.com/bkeepers/dotenv) to load `.env` and `.env.test` files in the "development" and "test" environments
