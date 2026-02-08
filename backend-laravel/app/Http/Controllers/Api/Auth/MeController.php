<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;
use App\Models\User;

class MeController extends Controller
{
    public function __invoke(Request $request): UserResource
    {
        $user = $request->user();

        assert($user instanceof User, 'User must be authenticated');

        return new UserResource($user->load('character'));
    }
}
