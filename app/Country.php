<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * ID, name UK NN type IN country_name
 */
class Country extends Model
{

    protected $table = 'country';

    protected $fillable = [
        'country',
    ];

    public function users()
    {
        $this->hasMany(User::class, 'country_id');
    }
}
