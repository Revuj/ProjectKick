<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class AssignedUser extends Model
{

    use Traits\HasCompositePrimaryKey;

    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'assigned_user';

    protected $fillable = ['user_id', 'issue_id'];

    protected $primaryKey = ['user_id', 'issue_id'];

    /**
     * @return
     */
    public function user()
    {
        return $this->hasOne(User::class, 'user_id');
    }

    /**
     * @return
     */
    public function issue()
    {
        return $this->hasOne(Issue::class, 'issue_id');
    }
}
