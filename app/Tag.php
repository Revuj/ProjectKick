<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * id
 * name
 * color_id
 */
class Tag extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps  = false;
    
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'tag';

    /**
     * @var array
     */
    protected $fillable = [ 'name', 'color_id']; 

    /**
     * @return 
     */
    public function color()
    {
        return $this->belongsTo(Color::class, 'color_id');
    }

    public function issues() {
        return $this->belongsToMany(Issue::class, 'issue_tag', 'issue_id', 'tag_id');
    }

    public function users() {
        return $this->belongsToMany(User::class, 'user_tag', 'user_id', 'tag_id');
    }

}
