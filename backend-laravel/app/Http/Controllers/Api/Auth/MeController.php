<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;

class MeController extends Controller
{
    public function __invoke(Request $request): UserResource
    {
        $user = $request->user();

        assert($user instanceof User, 'User must be authenticated');

        return new UserResource($user->load('character'));
    }
}
