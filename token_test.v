// SPDX-License-Identifier: Apache-2.0
//
// Copyright 2023-2024 zakuro <z@kuro.red> (https://x.com/zakuro9715)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import kuwa { Token }

fn test_token() {
	kind := 1
	text := 'abc'
	token := Token.new(kind, text)
	assert token.kind == kind
	assert token.text() == text
	assert int(token.text_len()) == text.len
}
