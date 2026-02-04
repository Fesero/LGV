<?php

namespace Tests\Feature\Auth;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\User;

class RegistrationTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Тестирование регистрации
     */
    public function test_register(): void
    {
        $this->withoutExceptionHandling();
        
        $response = $this->postJson('/api/register', [
            'name' => 'Ivan',
            'email' => 'ivan@cultivation.world',
            'nickname' => 'DragonSlayer',
            'password' => 'Secret123',
            'password_confirmation' => 'Secret123',
        ]);

        $response->assertStatus(201);

        $this->assertDatabaseHas('users', ['email' => 'ivan@cultivation.world']);
        $this->assertDatabaseHas('characters', ['nickname' => 'DragonSlayer']);

        $this->assertArrayHasKey('token', $response->json());
    }
}
