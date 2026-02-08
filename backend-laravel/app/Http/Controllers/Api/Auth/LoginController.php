<?php

namespace App\Http\Controllers\Api\Auth;

use App\DTO\Auth\LoginDTO;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Resources\UserResource;
use App\Services\Auth\AuthService;
use Illuminate\Auth\Events\Login;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    public function __construct(
        private readonly AuthService $authService
    ) {}

    public function __invoke(LoginRequest $request): JsonResponse
    {
        $dto = LoginDTO::fromRequest($request->validated());

        $user = $this->authService->login($dto);

        Auth::login($user);

        event(new Login('web', $user, false));

        return response()->json([
            'user' => new UserResource($user->load('character')),
        ]);
    }
}
