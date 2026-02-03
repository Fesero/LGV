<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('characters', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            
            $table->string('nickname')->unique();
            $table->integer('level')->default(1);
            $table->bigInteger('exp')->default(0);
            
            $table->tinyInteger('cultivation_realm')->default(1); 
            $table->bigInteger('current_qi')->default(0);
            $table->bigInteger('max_qi')->default(100);
            
            $table->integer('strength')->default(5); // Физ. атака
            $table->integer('agility')->default(5);  // Скорость/Уворот
            $table->integer('vitality')->default(5); // HP
            $table->integer('spirit')->default(5);   // Маг. атака
            
            $table->integer('location_id')->default(1)->index();
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('characters');
    }
};
