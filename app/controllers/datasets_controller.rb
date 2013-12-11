class DatasetsController < ApplicationController
  respond_to :json

  def index
    response = Echo::Client.get_datasets(params)

    if response.success?
      respond_with(results: response.body, hits: response.headers['echo-hits'].to_i, status: response.status)
    else
      respond_with(response.body, status: response.status)
    end
  end

  def show
    response = Echo::Client.get_dataset(params[:id])

    if response.success?
      respond_with(DatasetDetailsPresenter.new(response.body.first, params[:id]), status: response.status)
    else
      respond_with(response.body, status: response.status)
    end
  end

  def metadata
    format = params[:format] == 'native' ? nil : params[:format]
    response = Echo::Client.get_metadata(params[:id], format)

    if response.success?
      filename = "#{params[:id]}.#{params[:format]}.xml"
      send_data response.body, filename: filename, content_type: response.headers['content-type'], status: response.status
    else

    end
  end
end
