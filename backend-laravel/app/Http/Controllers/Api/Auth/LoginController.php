<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Services\Auth\AuthService;
use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
use App\DTO\Auth\LoginDTO;

class LoginController extends Controller
{
    public function __construct(
        private readonly AuthService $authService
    ) {}

    public function __invoke(LoginRequest $request): JsonResponse
    {
        $dto = LoginDTO::fromRequest($request->validated());

        $user = $this->authService->login($dto);

        $token = $user->createToken('login_token')->plainTextToken;

        return response()->json([
            'message' => 'Welcome back, Daoist!',
            'token'   => $token,
            'user'    => new UserResource($user->load('character')),
        ]);
    }
}
