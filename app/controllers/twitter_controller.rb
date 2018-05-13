class TwitterController < ApplicationController

  #- Post a tweet with pic
  #- Redirect back to pics.index with message
  def post_pic
    @pic = Pic.find params[:id]
    p @pic

    media_id = upload_pic(@pic)

    if media_id.blank?
      return redirect_to root_path, alert: t('notices.failed')
    end

    if tweet_status('Posted_from_Tweet_Pics', media_id)
      return redirect_to root_path, notice: t('notices.success')
    else
      return redirect_to root_path, alert: t('notices.failed')
    end
  end

  private

  #- Call Twitter API to upload a picture
  #- Return media_id registered in str
  def upload_pic(pic)
    request_url = 'https://upload.twitter.com/1.1/media/upload.json'
    header_params = build_header_params(request_url)

    twitter_uri = URI.parse(request_url)
    https = Net::HTTP.new(twitter_uri.host, twitter_uri.port)
    https.use_ssl = true
    https.verify_mode =  OpenSSL::SSL::VERIFY_NONE
    https.set_debug_output $stderr

    req = Net::HTTP::Post.new(twitter_uri)
    req['Authorization'] = "OAuth #{header_params}"

    media_id = ''
    image_file = File.open(Rails.root.join('public', 'pics', @pic.file_name))
    begin
      data = [
        [ 'media', image_file, { filename: @pic.file_name } ]
      ]
      req.set_form(data, 'multipart/form-data')
      res = https.request(req)
      if res.code == '200'
        res_json = JSON.parse(res.body)
        media_id = res_json['media_id_string']
      else
        logger.error('upload_pic failed:' + res.body)
      end
    ensure
      image_file.close
    end

    return media_id
  end

  #- Call Twitter API to post a tweet
  #- Return result in bool
  def tweet_status(status, media_ids)
    request_url = 'https://api.twitter.com/1.1/statuses/update.json'
    body_params = {
      'status' => status,
      'media_ids' => media_ids
    }
    header_params = build_header_params(request_url, body_params)

    twitter_uri = URI.parse(request_url)
    https = Net::HTTP.new(twitter_uri.host, twitter_uri.port)
    https.use_ssl = true
    https.verify_mode =  OpenSSL::SSL::VERIFY_NONE
    https.set_debug_output $stderr

    req = Net::HTTP::Post.new(twitter_uri)
    req['Authorization'] = "OAuth #{header_params}"
    req.set_form_data(body_params)
    res = https.request(req)

    if res.code == '200'
      return true
    else
      logger.error('tweet_status failed:' + res.body)
      return false
    end
  end

  #- Build header params to call Twitter API
  #- Return header_params in str
  def build_header_params(uri, body_params={})
    api_key = ENV['TW_API_KEY']
    api_secret = ENV['TW_API_SECRET']
    access_token = ENV['TW_ACCESS_TOKEN']
    access_token_secret = ENV['TW_ACCESS_TOKEN_SECRET']

    params = {
      'oauth_consumer_key' => CGI.escape(api_key),
      'oauth_nonce' => CGI.escape(SecureRandom.uuid),
      'oauth_signature_method' => CGI.escape('HMAC-SHA1'),
      'oauth_timestamp' => CGI.escape(Time.now.to_i.to_s),
      'oauth_token' => access_token,
      'oauth_version' => CGI.escape('1.0')
    }

    signature_key = "#{CGI.escape(api_secret)}&#{CGI.escape(access_token_secret)}"

    method = 'POST'
    request_oauth_header = sort_and_concat(params.merge(body_params), '&')
    signature_data = "#{CGI.escape(method)}&#{CGI.escape(uri)}&#{CGI.escape(request_oauth_header)}"

    hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, signature_key, signature_data)
    signature = CGI.escape(Base64.strict_encode64(hash))
    params['oauth_signature'] = signature
    header_params = sort_and_concat(params, ',')

    return header_params
  end

  #- Util func to stringify params
  #- Return joined k=v sets in str
  def sort_and_concat(params, delimiter)
    params = params.sort
    str = params.collect{|k, v| "#{k}=#{v}"}.join(delimiter)
    return str
  end
end
