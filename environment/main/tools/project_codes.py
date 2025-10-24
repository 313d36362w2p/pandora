import string, hashlib, sys

projects = (
    "pandora"
    "frida-scripts",
)

def to_base36(number):
    """Convert an integer to a Base36 string."""
    if number == 0:
        return '0'

    chars = string.digits + string.ascii_lowercase
    base36 = []

    while number:
        number, i = divmod(number, 36)
        base36.append(chars[i])

    return ''.join(reversed(base36))

def text_to_base36(text):
    """Convert each character in the text to its Base36 representation."""
    result = []
    for char in text:
        # Convert character to its Unicode code point
        charcode = ord(char)
        # Convert code point to Base36
        base36_representation = to_base36(charcode)
        result.append(base36_representation)

    return ''.join(result)

def sha256_of_base36(text):
    """Compute the SHA-256 hash of the Base36 representation of the text."""
    # Convert text to Base36 representation
    base36_text = text_to_base36(text)

    # Compute SHA-256 hash
    sha512_hash = hashlib.sha256(base36_text.encode('utf-8')).hexdigest()

    return sha512_hash

def main():
    # Example usage
    text = sys.argv[1]
    base36_text = text_to_base36(text)
    hash = sha256_of_base36(base36_text)
    print(f"Original text: {text}")
    print(f"Base36 representation: {base36_text}")
    print(f"Hash of Base36 representation: {hash}")

if __name__ == "__main__":
    main()
