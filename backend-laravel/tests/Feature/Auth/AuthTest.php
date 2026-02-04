<?php

namespace Tests\Feature\Auth;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\User;

class AuthTest extends TestCase
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

    public function test_login(): void
    {
        $this->withoutExceptionHandling();

        $password = 'Secret123';
        $user = User::factory()->create([
            'email' => 'test@sect.com',
            'password' => bcrypt($password),
        ]);
        
        $user->character()->create(['nickname' => 'ElderTest', 'level' => 99]);
        
        $response = $this->postJson('/api/login', [
            'email' => 'test@sect.com',
            'password' => $password,
        ]);

        $response->assertStatus(200)
                 ->assertJsonStructure(['token', 'user']);
    }

    public function test_cannot_login_with_wrong_pass(): void
    {
        $user = User::factory()->create(['password' => bcrypt('Correct')]);
        
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'Wrong!',
        ]);

        $response->assertStatus(422);
    }

    public function test_get_profile(): void
    {
        $user = User::factory()->create();
        $user->character()->create(['nickname' => 'MasterOfTests']);

        $response = $this->actingAs($user)->getJson('/api/me');

        $response->assertStatus(200)->assertJsonPath('data.character.nickname', 'MasterOfTests');
    }
}
