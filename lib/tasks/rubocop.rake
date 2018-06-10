if %w[development test].include?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  RuboCop::RakeTask.new('rubocop:frozen') do |c|
    c.options = ['--auto-correct', '--only=Style/FrozenStringLiteralComment,Layout/EmptyLineAfterMagicComment']
  end

  if Rails.env.development?
    namespace :db do
      %i[migrate rollback].each do |cmd|
        task cmd do
          Rake::Task['rubocop:frozen'].invoke
        end

        namespace cmd do
          %i[change up down reset redo].each do |t|
            task t do
              Rake::Task['rubocop:frozen'].invoke
            end
          end
        end
      end
    end
  end
end
