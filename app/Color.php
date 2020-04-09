<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * id
 * rgb_code
 */
class Color extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps  = false;
    
  /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'color';

    /**
     * @var array
     */
    protected $fillable = ['rgb_code']; 

    /**
     * 
     */
   public function tags() {
       $this->hasMany(Tag::class, 'color_id');
   }

   
}
