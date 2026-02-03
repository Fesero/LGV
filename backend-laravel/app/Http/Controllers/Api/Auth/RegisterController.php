<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\RegisterRequest;
use App\Http\Resources\UserResource;
use App\Services\Auth\RegistrationService;
use App\DTO\Auth\RegisterDTO;
use Illuminate\Http\JsonResponse;

class RegisterController extends Controller
{
    public function __construct(
        protected RegistrationService $registrationService
    ) {}

    public function __invoke(RegisterRequest $request): JsonResponse
    {
        $dto = RegisterDTO::fromRequest($request->validated());

        $user = $this->registrationService->register($dto);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user'  => new UserResource($user),
            'token' => $token,
            'type'  => 'Bearer'
        ], 201);
    }
}