# frozen_dtring_literal: true

class JsonFix < Faraday::Middleware
  MIME_TYPE = 'application/json'
  CONTENT_TYPE = 'Content-Type'

  def on_complete(env)
    if parse_response?(env)
      old_type = env[:response_headers][CONTENT_TYPE].to_s
      new_type = MIME_TYPE.dup
      new_type << ';' << old_type.split(';', 2).last if old_type.index(';')
      env[:response_headers][CONTENT_TYPE] = new_type
    end
  end

  BRACKETS = %w-[ {-.freeze
  WHITESPACE = [' ', "\n", "\r", "\t"].freeze

  def parse_response?(env)
    BRACKETS.include?(first_char(env[:body]))
  end

  def first_char(body)
    idx = -1
    char = body[idx += 1]
    char = body[idx += 1] while char && WHITESPACE.include?(char)
    char
  end
end

Faraday::Response.register_middleware(json_fix: JsonFix )
