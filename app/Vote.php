<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Vote extends Model
{
    use Traits\HasCompositePrimaryKey;

    protected $table = "vote";
    protected $fillable = ['user_id', 'comment_id', 'upvote'];


    protected $primaryKey = array('user_id', 'comment_id');

    public $incrementing = false;


    public function issue()
    {
        return $this->hasOne(User::class, 'user_id');
    }

    public function comment()
    {
        return $this->hasOne(Comment::class, 'comment_id');
    }


    public $timestamps = false;
}
