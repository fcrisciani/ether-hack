pragma solidity ^0.4.0;
contract TicTacToe {
    address[3][3] board;      // game board
    address[2] players;       // player's address
    bool gameFull;            // lock the registrations
    uint8 turn;               // 0 or 1 point to the next player turn (note starts from 0 so the owner always start first)

    event InGame(bool entered);
    event Placed(bool positioned);
    event Win(address winner);

    modifier checkTurn {
        if (players[turn] != msg.sender) {
            // emit event
            return;
        }
        _;
    }

    function TicTacToe() public {
        players[0] = msg.sender;
    }

    function register() public returns (bool) {
        if (gameFull) {
            InGame(false);
            return;
        }
        players[1] = msg.sender;
        gameFull = true;
        InGame(true);
        return true;
    }

    function move(uint8 x, uint8 y) public checkTurn {
        if (board[x][y] != 0) {
            Placed(false);
            return;
        }
        board[x][y] = msg.sender;
        if (_checkWinBruteForce()) {
            Win(msg.sender);
            return;
        }
        _changeTurn();
        Placed(true);
    }

    function _checkWinBruteForce() internal constant returns (bool win) {
        // first line, first column
        if (board[0][0] == msg.sender) {
            if (board[0][1] == msg.sender && board[0][2] == msg.sender ||
                board[1][0] == msg.sender && board[2][0] == msg.sender) {
                return true;
            }
        }
        // central cross and diagonals
        if (board[1][1] == msg.sender) {
            if (board[1][0] == msg.sender && board[1][2] == msg.sender ||
                board[0][1] == msg.sender && board[2][1] == msg.sender ||
                board[0][0] == msg.sender && board[2][2] == msg.sender ||
                board[0][2] == msg.sender && board[2][0] == msg.sender) {
                    return true;
                }
        }
        // last line, last column
        if (board[2][2] == msg.sender) {
            if (board[0][2] == msg.sender && board[1][2] == msg.sender ||
                board[2][0] == msg.sender && board[2][1] == msg.sender) {
                return true;
            }
        }
        return false;
    }

    function _changeTurn() internal {
        turn = (turn+1)%2;
    }

    // function checkWin(uint8 x, uint8 y, address p) private constant returns (bool res) {
    //     if (x > 2 || y > 2) return true;
    //     return (p == board[x][y]) && (checkWin(x+1,y, p) || checkWin(x,y+1,p));
    // }

}
