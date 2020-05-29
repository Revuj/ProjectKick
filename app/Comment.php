<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * ID
 * content NN
 * creation_date NN DF Now
 * issue_id -> issue NN
 * user_id -> user NN
 */
class Comment extends Model
{
    // Don't add create and update timestamps in database.
    public $timestamps  = false;
    
    /**
     * The table associated with the model.
     * 
     * @var string
     */
    protected $table = 'comment';

    /**
     * @var array
     */
    protected $fillable = [ 'content', 'issue_id', 'user_id']; 


    /**
     * @return 
     */
    public function votes()
    {
        return $this->hasMany(Vote::class, 'comment_id');
    }

    public function user() {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function issue()
    {
        return $this->belongsTo(Issue::class, 'issue_id');
    }


    // maybe fazer alguma coisa em relacao ao voto
}
