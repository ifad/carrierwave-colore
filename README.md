# CarrierWave Colore

CarrierWave adapter for the [Colore document storage system](https://github.com/ifad/colore).

## Setup

Add to your Gemfile:

```ruby
gem 'carrierwave-colore', git: 'https://github.com/ifad/carrierwave-colore.git'
```

And configure CarrierWave, e.g. in `config/initializers/carrierwave.rb`:

```ruby
CarrierWave.configure do |config|
  config.storage = :colore
  config.colore_config = {
    base_uri: 'https://my-colore-host/',
    app:      "MyApp",
    logger:   Rails.logger
  }
end
```

## Usage

Colore requires a unique identifier for each file uploaded. This should be
defined on your uploader with the `store_path` method.

For example, to use the record id:

```ruby
class DocumentUploader < CarrierWave::Uploader::Base
  def store_path
    "#{model.class.name}.#{model.id}"
  end
end
```

Or to generate a unique token for each record:

```ruby
class DocumentUploader < CarrierWave::Uploader::Base
  def store_path
    token
  end

  process :store_token

  def store_token
    model.token = token
  end

  def token
    @token ||= begin
      model.token || SecureRandom.uuid
    end
  end
end
```

Other than that, it just works like a regular CarrierWave adapter.

## Converting a document with Colore

(These examples assumes that `attachment` is a mounted Uploader on the
`Document` model.)

To convert a file to another format:

```ruby
file = Document.find(1234).attachment.file
file.convert('txt')
```

Where `txt` is a Colore conversion action. Note that conversion happens
asynchronously. You can pass a second parameter, which is an URL that will
receive a POST callback once the conversion is complete.

To then get the converted version:

```ruby
file = Document.find(1234).attachment.file
file.format('txt').read
=> "The quick brown fox..."
```

You can view all versions and formats as follows:

```ruby
file = Document.find(1234).attachment.file
file.versions
=> {"v001" => ["docx", "txt"], "v002"=>["txt", "docx"]}
```

It defaults to reading the current version, you can also specify the version:

```ruby
file = Document.find(1234).attachment.file
file.version('v001').format('txt').read
=> "The slow brown fox..."
```

## Serving files

For best performance you should use the [Colore Nginx
module](https://github.com/ifad/colore/tree/v1.0.0/nginx/ngx_colore_module),
so files are served  by Nginx rather than your application or Colore
itself.

You can get the URL of the file to use with this like this:

```ruby
url = Document.find(1234).attachment.url
=> "/document/doccy/1e723575/current/Support.docx"
```

Here is an example of what you can use in a Rails controller to serve this:

```ruby
def show
  @document = Document.find(params[:id])
  response['X-Accel-Redirect']    = @document.attachment.url
  response['Content-Disposition'] = "attachment; filename=#{@document.filename}"
  render nothing: true
end
```
