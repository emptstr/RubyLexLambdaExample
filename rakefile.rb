task :test => [:unit_assert, :integration_test]

task :unit_assert => [Rake::FileList.new("#{__dir__}/tests/unit/*test.rb")]

task :integration_assert => [:deploy, Rake::FileList.new("#{__dir__}/tests/integration/*integration_test.rb")]

task :deploy => :package do |task|
  sh "sam deploy --template-file packaged-template.yaml  --s3-bucket jag-lambda-deployments --stack-name RubyLexLambdaExample --capabilities CAPABILITY_IAM"
end

task :package => :build do |task|
  sh 'sam package --s3-bucket jag-lambda-deployments --template-file template.yaml --output-template-file packaged-template.yaml'
end

task :build do |task|
  sh 'sam build --use-container'
end

rule(%r{\w*integration_test.rb$}) do |filename|
  sh "ruby #{filename}"
end
