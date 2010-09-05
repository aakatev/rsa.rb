module RSA
  ##
  # Support for the PKCS #1 (aka RFC 3447) padding schemes.
  #
  # @see http://en.wikipedia.org/wiki/PKCS1
  # @see http://tools.ietf.org/html/rfc3447
  # @see http://www.rsa.com/rsalabs/node.asp?id=2125
  module PKCS1
    ##
    # Converts a nonnegative integer into an octet string of a specified
    # length.
    #
    # This is the {RSA::PKCS1 PKCS #1} I2OSP (Integer-to-Octet-String)
    # primitive.
    #
    # Refer to PKCS #1 v2.1, section 4.1, p. 8.
    #
    # @example
    #   RSA::PKCS1.i2osp(9_202_000, 2)    #=> ArgumentError: integer too large
    #   RSA::PKCS1.i2osp(9_202_000, 3)    #=> "\x8C\x69\x50"
    #   RSA::PKCS1.i2osp(9_202_000, 4)    #=> "\x00\x8C\x69\x50"
    #
    # @param  [Integer] x   nonnegative integer to be converted
    # @param  [Integer] len intended length of the resulting octet string
    # @return [String] octet string of length `len`
    # @see    http://tools.ietf.org/html/rfc3447#section-4.1
    # @raise  [ArgumentError] if `n` is greater than 256^len
    def self.i2osp(x, len)
      raise ArgumentError, "integer too large" if x >= 256**len

      len.downto(1).inject(String.new) do |s, i|
        b = (x & 0xFF).chr
        x >>= 8
        s = b + s
      end
    end

    ##
    # Converts an octet string into a nonnegative integer.
    #
    # This is the {RSA::PKCS1 PKCS #1} OS2IP (Octet-String-to-Integer)
    # primitive.
    #
    # Refer to PKCS #1 v2.1, section 4.2, p. 9.
    #
    # @example
    #   RSA::PKCS1.os2ip("\x8C\x69\x50")  #=> 9_202_000
    #
    # @param  [String] x octet string to be converted
    # @return [Integer] nonnegative integer
    # @see    http://tools.ietf.org/html/rfc3447#section-4.2
    def self.os2ip(x)
      x.bytes.inject(0) { |n, b| (n << 8) + b }
    end
  end # module PKCS1
end # module RSA
