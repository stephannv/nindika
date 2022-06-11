# frozen_string_literal: true

class NintendoImageTransformer
  def self.medium(url)
    medium_path = "c_fill,f_auto,q_auto,w_560"

    url.to_s.gsub("upload/ncom", "upload/#{medium_path}/ncom")
  end
end
