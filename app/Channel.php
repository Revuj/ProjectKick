<?php

namespace App;

use Illuminate\Database\Eloquent\Model;


class Channel extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps  = false;
    
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'channel';

    /**
     * @var array
    */
    protected $fillable = [ 'content', 'project_id']; 

    /**
     * @return 
     */
    public function project()
    {
        return $this->belongsTo(Project::class, 'project_id');
    }

    public function messages() {
        return $this->hasMany(Message::class, 'channel_id');
    }
}
