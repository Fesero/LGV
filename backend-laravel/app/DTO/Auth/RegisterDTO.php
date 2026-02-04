<?php

namespace App\DTO\Auth;

readonly class RegisterDTO
{
    public function __construct(
        public string $name,
        public string $email,
        public string $password,
        public string $nickname,
    ) {}

    public static function fromRequest(array $data): self
    {
        return new self(
            name: $data['name'],
            email: $data['email'],
            password: $data['password'],
            nickname: $data['nickname']
        );
    }
}
