require 'openssl'
require 'securerandom'

module SessionGenerator
  class Wrapper
    def encode_pepper_mint(request)
      server_key = Rails.application.credentials.secret_key_base
      timestamp = Time.now.to_i
      browser_id = create_browser_id(request)
      computer_id = create_computer_id(request)

      hk = sign("#{timestamp}|#{browser_id}|#{computer_id}", server_key)

      random_bytes = SecureRandom.random_bytes(256)
      encrypted_data = encrypt(random_bytes, hk)

      data_to_sign = "#{timestamp}|#{browser_id}|#{computer_id}|#{random_bytes}"
      signature = sign(data_to_sign, hk)

      "#{timestamp}|#{browser_id}|#{computer_id}|#{encrypted_data}|#{signature}"
    end

    def sign(data, server_key)
      digest = OpenSSL::Digest.new('SHA256')
      signature = OpenSSL::HMAC.hexdigest(digest, server_key, data)
      signature
    end


    private

    def encrypt(data, key)
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.encrypt
      cipher.key = key
      iv = cipher.random_iv
      encrypted_data = cipher.update(data) + cipher.final
      "#{iv}#{encrypted_data}"
    end

    def decrypt(data, key)
      iv = data[0..15]
      encrypted_data = data[16..-1]
      decipher = OpenSSL::Cipher.new('AES-256-CBC')
      decipher.decrypt
      decipher.key = key
      decipher.iv = iv
      decipher.update(encrypted_data) + decipher.final
    end

    def verify(data, signature, server_key)
      sign(data, server_key) == signature
    end

    def create_browser_id(request)
      Digest::SHA256.hexdigest(request.user_agent)
    end

    def create_computer_id(request)
      request_id = "#{request.remote_ip}|#{request.ssl? ? 'HTTPS' : 'HTTP'}"
      Digest::SHA256.hexdigest(request_id)
    end
  end

  def self.generate_session_id(request)
    w = Wrapper.new
    w.encode_pepper_mint(request)
  end

  def generate_session_id(request)
    w = Wrapper.new
    w.encode_pepper_mint(request)
  end
end
  # # Decoding function
  # def decode_data(encoded_data, server_key)
  #   timestamp, browser_id, computer_id, encrypted_data, signature = encoded_data.split('|')

  #   hk = sign("#{timestamp}|#{browser_id}|#{computer_id}", server_key)

  #   if get_timestamp(timestamp) < (Time.now - 1.year).to_i
  #     return false
  #   end

  #   if get_browser_id(browser_id) != create_browser_id(request, ENV)
  #     return false
  #   end

  #   if get_computer_id(computer_id) != create_computer_id(request, ENV)
  #     return false
  #   end

  #   data_to_verify = "#{timestamp}|#{browser_id}|#{computer_id}|#{encrypted_data}"
  #   if !verify(data_to_verify, signature, hk)
  #     return false
  #   end

  #   decrypted_data = decrypt(encrypted_data, hk)
  #   true
  # end
  # def get_timestamp(encoded_data)
  #   encoded_data.split('|')[0].to_i
  # end

  # def get_browser_id(encoded_data)
  #   encoded_data.split('|')[1]
  # end

  # def get_computer_id(encoded_data)
  #   encoded_data.split('|')[2]
  # end
