<?php

namespace App\Services\Auth;

use App\DTO\Auth\LoginDTO;
use App\DTO\Auth\RegisterDTO;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthService
{
    public function register(RegisterDTO $dto): User
    {
        return DB::transaction(function () use ($dto) {
            $user = User::create([
                'name' => $dto->name,
                'email' => $dto->email,
                'password' => Hash::make($dto->password),
            ]);

            $user->character()->create([
                'nickname' => $dto->nickname,
                'level' => 1,
                'cultivation_realm' => 1,
                'current_qi' => 0,
                'max_qi' => 100,
                'strength' => 5,
                'agility' => 5,
                'vitality' => 5,
                'spirit' => 5,
            ]);

            return $user;
        });
    }

    public function login(LoginDTO $dto): User
    {
        $user = User::where('email', $dto->email)->first();

        if (! $user || ! Hash::check($dto->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        return $user;
    }
}
