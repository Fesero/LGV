<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Character extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'nickname',
        'level',
        'exp',
        'cultivation_realm',
        'current_qi',
        'max_qi',
        'strength',
        'agility',
        'vitality',
        'spirit',
        'location_id',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
